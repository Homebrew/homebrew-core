class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.1.3",
      revision: "c94d381b03be117e7e57908edbf642104e00eb8f"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4117a9c9a33dce70bbf2a3852d630b0046229ff1c93dfa43dac2cfa7e298eb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccc97d91b5b4d34b7bb0649b94f1e9442428e23e5de7cfed111573b05481b91c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07a42834d231ac78bdbf73ae6fe1c57522faedb47fa3186e456ddd7a45035479"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d34e232f6adf216f63663fa17b3ed3068179ef21a24fc0ad3751d5a2b40ff24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79b0bdf02930b6e568af1f11bcc0f7b14efae1ee4d885badc8a1007020670208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ec269b3b149e2daa3fa4c8781d37c92fccff10477faffbd3812ff962483e98c"
  end

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
