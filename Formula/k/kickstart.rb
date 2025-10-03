class Kickstart < Formula
  desc "Scaffolding tool to get new projects up and running quickly"
  homepage "https://github.com/Keats/kickstart"
  url "https://github.com/Keats/kickstart/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "2a1a335c70b81757abf4240a52ebce231501f731f3d73decbed4133d18ad1386"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d95c2d3cf27851fc880368186b1dbc21311e66ae0b40bcc92be7ceead5f003a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43978e06cd88f0b1422d79ce521cf807884df6f31f05b196865ec1a1662a463c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "403b3eb69425af095c2a5fa75fd1590cfba5190627ce95b8394f18aa89983d01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "471f9a6ff9f0fe541dd13da8727d4cddca404cdea11698ebff5ca34abe6ddb1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a33b98800a5c86dd562706faaa5c4f1b9b4d4be00f1b073d2f79f88c70c683a1"
    sha256 cellar: :any_skip_relocation, ventura:       "2192bb7a80449ad9c47bab27f5347b3a07a634b2e0a06c342bf5d83e9411c805"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b17daab4bf60200fa04cc9af345b9f9c3788911a925137a69e63fa4f1bf40c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e8ed4eb9366108b3e1da2a2792bae23572462b90ab47756e0b0e4e3c93a9eb"
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
