class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "https://github.com/amperser/proselint"
  url "https://files.pythonhosted.org/packages/1f/95/0cec6b32b3031613468df80c94fbced8f3c3e38ff7f0101645c0acde6bd6/proselint-0.16.0.tar.gz"
  sha256 "2568db94db227ea3aa011f88ddb6f554707b99b2c7447666bf00d71c5d7167cb"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "276d4f0eb6a7f395b9337fbaf210fa0771a608d9847e3b0a30480d99cb26c551"
    sha256 cellar: :any, arm64_tahoe:       "f8a636473c4a19a5d0c2be4473cde65887f6d0c4458ee0b7ea31f0f6a4313602"
    sha256 cellar: :any, arm64_sequoia:     "b54b0554049ff36fe4e68f2a79a2f5a0e2fdb6c3f61acb2efa9a7bfcfae62fe5"
    sha256 cellar: :any, arm64_linux:       "3cebaf0317bb506f1f7ec1f753fe52e29d7df22b9b012d9fa6e01176cc904135"
    sha256 cellar: :any, x86_64_linux:      "d9d330230dd3d267ea0e1101fdbf4a41a752c07998a89fa0f729202faf486966"
  end

  depends_on "pybind11" => :build # for `google-re2`
  depends_on "rust" => :build # for `google-re2-stubs`
  depends_on "python@3.15"
  depends_on "re2" # for `google-re2`

  resource "google-re2" do
    url "https://files.pythonhosted.org/packages/6b/60/805c654ba53d685513df955ee745f71920fe8e6a284faf0f9b9dc19b659c/google_re2-1.1.20251105.tar.gz"
    sha256 "1db14a292ee8303b91e91e7c37e05ac17d3c467f29416c79ac70a78be3e65bda"
  end

  resource "google-re2-stubs" do
    url "https://files.pythonhosted.org/packages/e5/a4/d8d16007eb6a6eb137ec3b6344a67199837e14a73709efeaa7285d2660eb/google_re2_stubs-0.1.1.tar.gz"
    sha256 "f5ebef2f4188957bf980a5ad88ab266589638e5090329e6a0fde99f6bb684657"
  end

  def install
    # `google-re2` detects CI to build `re2` but we skipped to use brewed one
    ENV["GITHUB_ACTIONS"] = nil

    # Otherwise compilation of `google-re2` fails with the following error:
    # $HOMEBREW_PREFIX/include/absl/base/policy_checks.h:81:2: error: "C++ versions less than C++17 are not supported"
    ENV.append "CXXFLAGS", "-std=c++20"

    virtualenv_install_with_resources
  end

  test do
    (testpath/"sentence.txt").write <<~EOS
      John is very unique.
    EOS
    output = shell_output("#{bin}/proselint -o compact check sentence.txt", 1)
    assert_match "Comparison of an uncomparable", output
  end
end
