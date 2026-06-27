class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.2.2",
      revision: "b05881cf967a5a09e19866799d0edfd40675803a"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30b3d1bc580fa98befa1857963d9f11d2e47a36df41f099ea3934199871318e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "276000aec740958de2b7391642c29af303430b108f5e8668705642b767b5c0af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cbf1f084c340ed1ceac18587fda01173386ac49b8db7c6194fd27fbadabc81c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c3457bbe4b875e5f46f04ea44cc8e34ecb83cf8639aac687ed3cd73e1e26314"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "110ac2ba0295e03379b5eab6bcd3d13268023489bcd88a20d708aa59f0cfb4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c119b6f04ec4a50e327ab6f0157da03b4706f7c2339f09d515fba36c0fbcfc4a"
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
