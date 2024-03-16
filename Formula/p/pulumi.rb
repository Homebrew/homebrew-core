class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.111.1",
      revision: "c465c02f2979b8a7bb028268df14dfefa3cd89bf"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffde8d5e29b7524a9c3b98d3366f7bb1af9d74c6e982cc3c3f275e8951c57c00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f192c61372175e5e7c6a19647441cb77410ce0c51f90255e44e3cfa9186e4579"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3de762931fc70ca1dd61a0beac09667b429d845ab513b60da3b59598e239d5ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "020d49f55c98a4d1c3013f64b67b620a07140034944ecc398fa49bb4ec7ae6b7"
    sha256 cellar: :any_skip_relocation, ventura:        "13aedb94c7462e840726573bf88ca1bbfe9d62b781df3425c38d9e1a2c985617"
    sha256 cellar: :any_skip_relocation, monterey:       "b312805f409851eba81a1ac3ff7cacaf2229b90666c4b26396c385c8cad945b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "459c19d9bbbc7788d5ea5ca9ae1c57a26f2f90c9833593a4f888e3fdb1c7eb59"
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
