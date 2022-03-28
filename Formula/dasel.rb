class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.24.1.tar.gz"
  sha256 "ca1fa030f41abcd3659e76d7413ce14c551f40d41769e7a000a46f4fea6d0b64"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9d9894d83100f1407bf4f0df700d2f474bb8910ecfce087d88017ba2824b8b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "facee5102dc91bc3d8a174566a87ca5d361326d3434886bb93fdac17b36fcfba"
    sha256 cellar: :any_skip_relocation, monterey:       "03c7368923617952634ea6cb86c7e6d33d3736a19108754ee23e06b64ccf9f98"
    sha256 cellar: :any_skip_relocation, big_sur:        "235b160ed229f5876c2831847be0ae3434b3273dd0073844a732665a707f6500"
    sha256 cellar: :any_skip_relocation, catalina:       "d350f58d0d5a209d5041e5612fbfcaae27a3424611ac327486f252873d09cc65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1265819ed321f132c7921529673fa2d258965f652f18cdecb40ee88f7412254a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
