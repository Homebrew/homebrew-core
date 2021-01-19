class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.4.0.tar.gz"
  sha256 "90ddaaf4a6b76c490e0664a55946342055ba70c0ed40d52724440fa8ac0b45db"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9faf84b5ad2546b43894c3842120c0c7f3d18c96c020f915a7fedb29755dad2e" => :big_sur
    sha256 "02ab9873c86d26e2f79102bd85a7bd9990ada427bd5654c36af1c28bab0d73f0" => :arm64_big_sur
    sha256 "59f92a95d01a17bee1e13506ff6411eea6b7cb1f1a3e0d028ceaef928193a0d1" => :catalina
    sha256 "cc13961cd45cac3656448c7a3598a9805911ee6e76f5552aa26b3a14c55f57ba" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}",
      "./cmd/crane"
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
