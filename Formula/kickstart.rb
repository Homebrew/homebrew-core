class Kickstart < Formula
  desc "Scaffolding tool to get new projects up and running quickly"
  homepage "https://github.com/Keats/kickstart"
  url "https://github.com/Keats/kickstart/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "98f25f870d6b1bff9bb22a485cf307d42a1d4243550080cf0d122c6d71c23ded"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b1dcc991129ca4a822b8b8ac5e8be164a7bf65b6ca56fce267300fe0770c6ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdb5a1637f755d3d0c4f7db16d136c6a854f40fc5edfa19a351b200576f572ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd5aa5cde9dbf7f7e00616648d0ca0aff07ba007e4d117fcee57b7c837dc19d8"
    sha256 cellar: :any_skip_relocation, ventura:        "23355c3677b666b7079674e5c8604a0b26242dae04cd9b2448b70a8261009dc7"
    sha256 cellar: :any_skip_relocation, monterey:       "2e0c6a85d535ee38876825adb4dd6eb9ea959534bc125e796ffe3625bee10940"
    sha256 cellar: :any_skip_relocation, big_sur:        "a339668d1c7d9ded0f1c061cea821dfe3090b734f400e162c7746d5ca6b5e013"
    sha256 cellar: :any_skip_relocation, catalina:       "5beff86259f7c42160e4d9cb535b4edae33966cd5aa8468c4a420c614f5a9197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "731d389d83ec12043779f96dbee9049d09a97768a2c2d6e1993a3ae10ee0a181"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Create a basic template file and project, and check that kickstart
    # actually interpolates both the filename and its content.
    #
    (testpath/"{{file_name}}.txt").write("{{software_project}} is awesome!")

    (testpath/"template.toml").write <<~EOS
      name = "Super basic"
      description = "A very simple template"
      kickstart_version = 1

      [[variables]]
      name = "file_name"
      default = "myfilename"
      prompt = "File name?"

      [[variables]]
      name = "software_project"
      default = "kickstart"
      prompt = "Which software project is awesome?"
    EOS

    # Run template interpolation
    system bin/"kickstart", "--no-input", testpath.to_s

    assert_predicate testpath/"myfilename.txt", :exist?
    assert_equal "kickstart is awesome!", (testpath/"myfilename.txt").read
  end
end
