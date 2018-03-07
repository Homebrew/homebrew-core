class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/chneukirchen/nq"
  url "https://github.com/chneukirchen/nq/archive/v0.3.1.tar.gz"
  sha256 "8897a747843fe246a6f8a43e181ae79ef286122a596214480781a02ef4ea304b"
  head "https://github.com/chneukirchen/nq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "60d65eb6a06549557a866ecd6b6c5570e490f02cb0f84e53f0e6198d2535f1a3" => :high_sierra
    sha256 "875e20911bc821d2c160bf3d7c267a988bd691cc2d1f84a8cb1d48d4b586dbc6" => :sierra
    sha256 "80e3a08a3453ed509bbd4bfab3e9c589449277578024b2f114744c5e716e5595" => :el_capitan
  end

  depends_on :macos => :yosemite

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/nq", "touch", "TEST"
    assert_match /exited with status 0/, shell_output("#{bin}/fq -a")
    assert_predicate testpath/"TEST", :exist?
  end
end
