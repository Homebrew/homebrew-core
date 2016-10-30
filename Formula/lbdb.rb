class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/debian/lbdb_0.41.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/lbdb/lbdb_0.41.tar.xz"
  sha256 "fc9261cdc361d95e33da08762cafe57f8b73ab2598f9073986f0f9e8ad64a813"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "ea5e8fc0989f5f829e886781212abd6a4bc2d812a61a35e87c17709095f5ba59" => :sierra
    sha256 "d336634147b6e8466b09c0e6918733381cb3f0e7d933660969c9d7ffea53d724" => :el_capitan
    sha256 "1f7e155f77361a674442f376da2119486509f2f2802cca6ef6ea2b81b95f5339" => :yosemite
    sha256 "d9a370f2aa20e318db463903e5e6f1aa967a718ef97346c7b3eeafd7eb699a0e" => :mavericks
  end

  depends_on "abook" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{libexec}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
