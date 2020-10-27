class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.15.0.tar.gz"
  sha256 "5359d6e241eca2bc3bdb7ddf9344b4ef8315cbe7629775c09e0ab7ed70310c8d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bc6e214a67b692d17af8cb67ea6dd72d64254842e0d9f4d614d65bf6e786ce0" => :catalina
    sha256 "7cb1d26f16dd143a134362cf0909901d64516f25d0f856fdc2fc2b0b76ed2e48" => :mojave
    sha256 "87cff82607f02e299989ea5c13687895c0eb77c9fb60dcefaf76c8667d5e7965" => :high_sierra
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
