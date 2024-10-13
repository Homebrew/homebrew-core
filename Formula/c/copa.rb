class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "97bc6a556bc662ea4c10f26835c2d10b2ebcf6c33303045520cc1aa43246148b"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b3d0a4c15be52280977e638e6e8bead27b8057b4435064efef812891a86f1557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f89003148109d2178e69e3924b35e784f1c9a630c39f7b079ab2726c73831686"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d789f96fc651ef5c29aa9b9d49b9cd88123c7fef895811a98be5cf0f085a6fc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb1aa3526adb019558f307244ac3723f23804ef4f64d0f1bcc6a26f7f1ccaa0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "66af102888b4d465b61b51309f43f51ca20a1fb2453c21cd9b7bc1b9e66beba3"
    sha256 cellar: :any_skip_relocation, ventura:        "49a13384112441714a39b2fbc9a9ccb4e20eca844b3723e14ae08dc982848db3"
    sha256 cellar: :any_skip_relocation, monterey:       "c7299c0d8387635b261aca35e117d6aca653dea67ab0f8a9a60f9eafb4f5de6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feaac62ca9df59c13d4f26f86412a5a038dcf9da6609954fda26d3614546540a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/project-copacetic/copacetic/pkg/version.GitVersion=#{version}
      -X github.com/project-copacetic/copacetic/pkg/version.GitCommit=#{tap.user}
      -X github.com/project-copacetic/copacetic/pkg/version.BuildDate=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Project Copacetic: container patching tool", shell_output("#{bin}/copa help")
    (testpath/"report.json").write <<~EOS
      {
        "SchemaVersion": 2,
        "ArtifactName": "nginx:1.21.6",
        "ArtifactType": "container_image"
      }
    EOS
    output = shell_output("#{bin}/copa patch --image=mcr.microsoft.com/oss/nginx/nginx:1.21.6  \
                          --report=report.json 2>&1", 1)
    assert_match "Error: no scanning results for os-pkgs found", output

    assert_match version.to_s, shell_output("#{bin}/copa --version")
  end
end
