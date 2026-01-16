class Kickstart < Formula
  desc "Scaffolding tool to get new projects up and running quickly"
  homepage "https://github.com/Keats/kickstart"
  url "https://github.com/Keats/kickstart/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "0888ca59bc11e2c9531957047973b3f4d28e4270c03d1272f29d8b73f12bb142"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4da704a13fe097f488ef7ffff14c2449e08ce87f0863c4d3b0ec1fb4d84d817f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98d5fc2c7dd19846e28d7d3ac0aded2ba9d05a7027a2cd9b7d5d544aa643ae50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63ac54acda7d230418bb0b0fd3d43a6920eda599e6aebd8e6ad654ff94f5207c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ada53abf074cf433bcc799226148790a68578c86ecde501f4c55f79f7969ade6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5be6b2132ab93b209560ebe642576a39d6e7606ff5bd90215bac6415d2d0c32a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd13f0e62244332963acd82c481bd12d3f917c4adce0a7b62bfb4ee6a059d73b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "cli", *std_cargo_args
  end

  test do
    # Create a basic template file and project, and check that kickstart
    # actually interpolates both the filename and its content.
    template_dir = testpath/"template"
    output_dir = testpath/"output"

    (template_dir/"{{file_name}}.txt").write("{{software_project}} is awesome!")

    (template_dir/"template.toml").write <<~TOML
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
    TOML

    # Run template interpolation
    system bin/"kickstart", "--no-input", "--output-dir", output_dir, template_dir

    assert_path_exists output_dir/"myfilename.txt"
    assert_equal "kickstart is awesome!", (output_dir/"myfilename.txt").read
  end
end
