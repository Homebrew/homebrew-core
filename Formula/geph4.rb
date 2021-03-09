class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.2.1.tar.gz"
  sha256 "bb5aaadb4fc55a22ec0be59761f9f5e71299e2c944c8b74432b45f278fb755c9"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a0babcae532a1c52d15807c1da33337260ed0130a176b91dff3b3462e304e7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "edbe96c7e8395475bf3bb99a2b183ee34b474ebb325fc095eaa2fd052cc770c3"
    sha256 cellar: :any_skip_relocation, catalina:      "484bf78360f764332036a34b5d260465a9ac52a57655087efac375389fa22d23"
    sha256 cellar: :any_skip_relocation, mojave:        "97f3ed332edc560ae226d9b1c49ec3a7a17fa4583a90f9154fac24a81fc1fd58"
  end

  depends_on "rust" => :build

  def install
    File.delete("Cross.toml")
    remove_dir(".cargo")
    Dir.chdir "geph4-client"
    system "cargo", "install", "--bin", "geph4-client", *std_cargo_args
  end

  test do
    assert_equal "{\"error\":\"wrong password\"}",
     shell_output("#{bin}/geph4-client sync --username 'test' --password 'test' --credential-cache ~/test.db")
       .lines.last.strip
  end
end
