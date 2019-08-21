class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v3.5.17",
    :revision => "9a2a679d8e0de1940fbea59801e59023a745df32"

  bottle do
    cellar :any_skip_relocation
    sha256 "bebaba8f55a32d3ec8e34cde7ee2b98f7e8204a696df4c70fae97edef8f805e1" => :mojave
    sha256 "c2fe6c2df8192a41810c56255fb846684c8c495565c1b72add6ac89b903063e9" => :high_sierra
    sha256 "62396265c6505142f1cc2053820d86d05fbda8f8a0bc8080c6b9f2176744cd24" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/devspace-cloud/devspace"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"devspace"
      prefix.install_metafiles
    end
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
