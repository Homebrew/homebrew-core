class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.4.2",
      revision: "23dd3af5e19a02d4f4baa5b2f242645a1a3af629"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "06dcbe4ca7fbfa88d4af33d4f0dfa53d5395473f6d613c7994bcf27bc5c38dd2" => :big_sur
    sha256 "67ac12e45426ebf355a9245cd21270874938d649fa84093f046832ac27ff39e7" => :catalina
    sha256 "62d4fe60217d65485965ae53fc33084d191fe4e4d37ffb91fdf336b8b0166e66" => :mojave
    sha256 "49f954049e04e42efa8f9a27778e0ff2322e7527ee67a5fb396d782b8814ac43" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"helm", "completion", "bash")
    (bash_completion/"helm").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"helm", "completion", "zsh")
    (zsh_completion/"_helm").write output
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "Version:\"v#{version}\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output
    end
  end
end
