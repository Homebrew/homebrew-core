class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.0.4",
    :revision => "1c339945c993f9bab0f9a8897f3f3137ed6be0be"

  bottle do
    cellar :any_skip_relocation
    sha256 "540b0bb7859f32f1587e40fb33c86c99423f48b93561b455de0a1dc7c71d1979" => :catalina
    sha256 "a4c25bf8a8072fde6717d792a82be7588c7c809be5b3d42755ab5c5d7176c22f" => :mojave
    sha256 "07a265e980a1dd9f955815204f0c2bb39d4335970dbddfde86d113f1c01f916e" => :high_sierra
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
