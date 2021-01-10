class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  # Remove "Cargo.lock" resource at version bump!
  url "https://github.com/rcoh/angle-grinder/archive/v0.15.0.tar.gz"
  sha256 "5359d6e241eca2bc3bdb7ddf9344b4ef8315cbe7629775c09e0ab7ed70310c8d"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2390d043926186166613411b4020bc2fa2342fa8e2e8ce71186b09318f56c368" => :big_sur
    sha256 "4bc6e214a67b692d17af8cb67ea6dd72d64254842e0d9f4d614d65bf6e786ce0" => :catalina
    sha256 "7cb1d26f16dd143a134362cf0909901d64516f25d0f856fdc2fc2b0b76ed2e48" => :mojave
    sha256 "87cff82607f02e299989ea5c13687895c0eb77c9fb60dcefaf76c8667d5e7965" => :high_sierra
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  # Replace stale lock file. Remove at version bump.
  resource "Cargo.lock" do
    url "https://raw.githubusercontent.com/rcoh/angle-grinder/6c5cf552dec605aac75c3da04e8618518b63abf2/Cargo.lock"
    sha256 "a52f0e1d81eb77bdb10f9fa6b4bc5a2f4551045794570ac5d766de9085da4a54"
  end

  def install
    rm_f "Cargo.lock"
    resource("Cargo.lock").stage buildpath
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
