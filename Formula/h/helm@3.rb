class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.20.0",
      revision: "b2e4314fa0f229a1de7b4c981273f61d69ee5a59"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2339539c5abb0f6b591fd785c835448a74a5ff8de81843f2467b5e3d8228e7ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a270381448f0c0f6a851b1c2c93df12c93359ec815cb46716c03c1c1311c8a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e64c0cb0f3e132d18147f5c99e4522384049a44c18de32bda70d2e3beb7f539a"
    sha256 cellar: :any_skip_relocation, sonoma:        "32aab9cccea7e889bcb269cffdf0aaccfbad501407b7ba6e53fd9ae4b8a8c881"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3725770e2c7547599e1884fd6c19f57ed4b1ae08a21345ee7c9cc7a5b757e825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32b818e1be7060d7cdd2ca1a8d8046b88dddabc31813719998a8170dbb5db1da"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin/"helm", shell_parameter_format: :cobra)
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end
