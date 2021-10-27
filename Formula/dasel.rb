class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.21.2.tar.gz"
  sha256 "825830b64e555b86d04c8b8f258162cf19e8fbc89b14986815e615061e5d0bbe"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "07023f5c64b771c14ee66347e5c4857c40aef480f629b97e33d475dc1b0dcea0"
    sha256 cellar: :any_skip_relocation, big_sur:       "4c588d2dc6f079c3964e4c93d46d0574110480048888204c9eb0937e4cea3e9e"
    sha256 cellar: :any_skip_relocation, catalina:      "5e99d16b41132905368fb9c2df25623e60e9640a8a533466d90c52886677ea5c"
    sha256 cellar: :any_skip_relocation, mojave:        "4f156e178ee7ad520b2d9b8fbdfea3c15a0412a9c9c4dba67c3c36b2ae66a8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b5838ab6222d6b564d1b9029a0d9b5d7d6856f47488f31794f87e93b7ccba9b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
