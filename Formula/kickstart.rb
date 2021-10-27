class Kickstart < Formula
  desc "Scaffolding tool to get new projects up and running quickly"
  homepage "https://github.com/Keats/kickstart"
  url "https://github.com/Keats/kickstart/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "98f25f870d6b1bff9bb22a485cf307d42a1d4243550080cf0d122c6d71c23ded"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cae28a7a5048e193e6c901b0e68645d7f9858fdbce23b0d94fc9ccfec42f154"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa5e270b58a74bf343c3b4482c6f4fcb5badca3d552d50c37fbb2f51447dcea1"
    sha256 cellar: :any_skip_relocation, monterey:       "67ab36ce6bc37d9092b3a6959e074975d7aa5532337087595d7df5ef2235cb9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "312faa72771af3a139b1de745f164e7a95ac8705ab3db7f2bf6a7ddc451f372f"
    sha256 cellar: :any_skip_relocation, catalina:       "6dbb7cc02996cbde1ead056a058e26adc420f6d7d8e0892ed072659c72e6d141"
    sha256 cellar: :any_skip_relocation, mojave:         "ba2d8ea34e7bf6aa226c2c6dd5ffeea606a2046113250fdb85a3d92655456bbc"
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
