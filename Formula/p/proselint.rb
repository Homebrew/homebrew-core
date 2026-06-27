class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "https://github.com/amperser/proselint"
  url "https://files.pythonhosted.org/packages/1f/95/0cec6b32b3031613468df80c94fbced8f3c3e38ff7f0101645c0acde6bd6/proselint-0.16.0.tar.gz"
  sha256 "2568db94db227ea3aa011f88ddb6f554707b99b2c7447666bf00d71c5d7167cb"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70add61cf2da1bde43078ae2bbc702350bb795783ab4bc021a38ede477e51521"
    sha256 cellar: :any,                 arm64_sequoia: "a8661e7ef69d0e8af504df9eb2228a23d7c0383033438c109d9f5d4a83fb8a4f"
    sha256 cellar: :any,                 arm64_sonoma:  "8e819d7c870eb0f5f0b0393e7bf563b8141de5e96b48a7cb88e3e42c0dacc314"
    sha256 cellar: :any,                 sonoma:        "5e7b5f1a467e8181896b1dfafa12250c01611b74476cd06374bca1ef1098f468"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fe140e4c71afe17846fff6bd68be0bfbd1dcbce43c4517a0e5fc4c58690b856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2c95d910b7eabf8d86dfb836a295c7d260a497da9ac3568362da22d553c6d52"
  end

  depends_on "pybind11" => :build # for `google-re2`
  depends_on "rust" => :build # for `google-re2-stubs`
  depends_on "python@3.14"
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
