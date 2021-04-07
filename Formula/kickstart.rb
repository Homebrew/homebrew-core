class Kickstart < Formula
  desc "Scaffolding tool to get new projects up and running quickly"
  homepage "https://github.com/Keats/kickstart"
  url "https://github.com/Keats/kickstart/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "f15f09467bf13f89dced49ba621c478857e2ee96fa87377ef0e922aae52e4677"
  license "MIT"

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
    system "#{bin}/kickstart", "--no-input", testpath.to_s

    assert_predicate testpath/"myfilename.txt", :exist?
    assert_equal "kickstart is awesome!", (testpath/"myfilename.txt").read
  end
end
