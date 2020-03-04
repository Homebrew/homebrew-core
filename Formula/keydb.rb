class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/JohnSully/KeyDB/archive/v5.3.2.tar.gz"
  sha256 "ed63e45889da4bec3cf1cc53e213c1d2f5b5569e079cb3f22dfe0c49cea1166b"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ecbd75e637fc40e8131a35c594b9a028634d55361df0ed83d310b2270c01b5a" => :catalina
    sha256 "920ee8aede6c62432d4433fcda41855d4168c039b8e3948c96c38ed98f47d21b" => :mojave
    sha256 "9a4b08c647a79c5e63e0e3d048cb879adf2b6ec2afe223019369486612cc4845" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end
