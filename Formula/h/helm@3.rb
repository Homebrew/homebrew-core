class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.20.2",
      revision: "8fb76d6ab555577e98e23b7500009537a471feee"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36e65f971b49691282c0ccf857ebab517b39ec5ea5d5c4095a5b9fb8a30e214f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78fb91da7b55043b59d9cfb23a25f1c1d3e8ab025af63a970b874452d0fc7d9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e314ceb85c8a3be1e1e11ece583f3b80c2b66a6207a98043bbc20bcfe9efea25"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1869401bc09579a56f5f47bc6d570b573b0e07f7a8956cd92a677f4981d3507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f4729ba2c3e8c6a24a2517047582937c22c515e57b071acbbd45e0cce72b779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83e2039e901f89b0bcd68e3ef1f76cc744b816b6faaf5c9ebc843a67f1e2cf1"
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
