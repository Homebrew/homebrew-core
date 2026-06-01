class Cmuxinator < Formula
  desc "Start cmux projects from tmuxinator-style YAML files"
  homepage "https://github.com/alpeshvas/cmuxinator"
  url "https://github.com/alpeshvas/cmuxinator/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "091924a9b1f5cc8c239eb1b4016925ec7cc657aae1fb1c62a0c8aa7906add4d5"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "cmuxinator #{version}", shell_output("#{bin}/cmuxinator --version")

    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    system bin/"cmuxinator", "new", "brewtest"
    assert_path_exists testpath/".config/cmuxinator/brewtest.yml"
  end
end
