class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "dd1531d7869a0a09437b621fcf40f5306d867fb98e17f6d0fe03862c15707643"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "778a853ebabcd4bb6d84fe51dfb781deeb456eed7ad3422a74997909fdb38688"
    sha256 arm64_sequoia: "1b60ef58db787ce17287841f8640bd0dc05f201ce3b123974ef9974cb580afe2"
    sha256 arm64_sonoma:  "ca4e5f918dd595ab0ec44f6a5713c68a62a122156fbc5309216196aba532e8d6"
    sha256 sonoma:        "2ed109911f2461e87d030dbcd7c8df78eef6bd624ea08d240e4bebc1b3993f4c"
    sha256 arm64_linux:   "d2c4a17a05be0ec0b1b35ecb370349ebe59aea9ede6fc047a04231baea2c2d25"
    sha256 x86_64_linux:  "020289b4becefda52ea77e985bca6946f6114da7247c6a4ad6c204ff190be597"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
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
