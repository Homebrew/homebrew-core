class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "902c1d3a323098211bc87831705fc09c3803d1035ac42fa85449740ca8cc421c"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "db8107b8ea6cc053372fe67efbf324dc785c5be044e448c2609576fa91d1aeb5"
    sha256 arm64_sequoia: "c8e4bc233bec1cc9b78f3197d54513d0d7328e82a14239362af37239904069b6"
    sha256 arm64_sonoma:  "a6dfcb042a838bb07dca159e3f4373602d28a3c1925d3525007e20ab2cda9475"
    sha256 sonoma:        "482d3960707c4f8572dc21f7418e2663a460592d5b121f1a85856f89037c31b2"
    sha256 arm64_linux:   "ed1d449208fdb1aa6667ea1cff4d6aab9fd7c148aebfd630de830f9f1f6ff582"
    sha256 x86_64_linux:  "ec1ebcd223c9bad25343377952d3675727322722f5672e919eb3d194f361b0e7"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-cli")
  end

  test do
    project = testpath.to_s.split("/").last
    assert_match "Initialized '#{project}' successfully", shell_output("#{bin}/helix init")

    assert_path_exists testpath/"helix.toml"

    assert_match "Added 'test' successfully", shell_output("#{bin}/helix add local --name test 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local --name test 2>&1", 1)

    assert_match "helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end
