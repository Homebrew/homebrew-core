class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.120.0",
      revision: "f1e4b4ff94486dced178cbc51179ef380db6393d"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0597f1f262cfbd3ab011eb29fc6679e4d65625f264ca4c4ddd4888ae7472af8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ace3fab7b4efc5132ff8cbb5e79a54aaa5e1e15cb1a234b38f4ad29e5a9bbf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d86cd50507a3243d4ebce69abca11d14283aa79e51eed4c1daecdc2dca6cb8c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e795e185108687a6d77949e3b83220d59d2f2647bf027f474414efd662124391"
    sha256 cellar: :any_skip_relocation, ventura:        "6149f380c0373968c4f82c61a5f404e5bd893c26e3071b22d1a9d322bb5e3399"
    sha256 cellar: :any_skip_relocation, monterey:       "3d17f4647d19b62a09d3eadeb50df3e377dec08f67fac601fe139903c445402b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "450deaa39561d66f6ecc31fc98fd8ea8ff1723b9835908c86fd5c00dd8acdaba"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
