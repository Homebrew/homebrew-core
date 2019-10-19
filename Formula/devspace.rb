class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.1.0",
    :revision => "2bb491c6e471988a4e198dbd39ca9234fd3ea163"

  bottle do
    cellar :any_skip_relocation
    sha256 "316842d901e54febe26b8bf0225a47c4c591aebd03deae50efff32a858119b1a" => :catalina
    sha256 "ef659986949365c64d9ab86352878f92c699c0f95ade687713e3cd2e89de3bc4" => :mojave
    sha256 "0e8e827b381338c396cd7fbfb20eae184dafd16e20fa06d5cd147aff9f0fc147" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath

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
