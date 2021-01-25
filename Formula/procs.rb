class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.10.10.tar.gz"
  sha256 "dbef5afc118f54e794b539b86fc3a53ac4a94ec566ad78cddfe0580940388421"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "212bb791a261e19856eda7ff7cdae3ee3d96a5553f5f1a6fd94a882b8663121f" => :big_sur
    sha256 "20c0b4166c8968e34e777e67f934890ad4449d4619db6cae53f6b14d3d289c3b" => :arm64_big_sur
    sha256 "7bd872fd51bc821cb102ed245545918b6c95356395a66665807dc089c245409e" => :catalina
    sha256 "435573168fd92844915ffc08bb1d29b424549fb805ee9205094d27892ec0c33a" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
