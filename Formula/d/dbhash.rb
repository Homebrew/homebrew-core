class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2025/sqlite-src-3510100.zip"
  version "3.51.1"
  sha256 "0f8e765ac8ea7c36cf8ea9bffdd5c103564f4a8a635f215f9f783b338a13d971"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7eba5ac6018408499fa0be37e463713fc358bfc20e8c153d449dbf98510a4c3"
    sha256 cellar: :any,                 arm64_sequoia: "47b0312a6d4e49c7aa9f2faffd0eb2b8502d465102317a547f914a258791660e"
    sha256 cellar: :any,                 arm64_sonoma:  "d6ebfb41932a21bc3656b97ae4bd1e40423e8f04b113ee1b05833a6bde077b77"
    sha256 cellar: :any,                 tahoe:         "cbcb520a3c9b06048b86e3fea0deab1f1a3a81d6aaad9dc42e7746321108de2a"
    sha256 cellar: :any,                 sequoia:       "67712046f79b3d0703253dd71685c8a04f5fc1e2f77340c49e88f6464cea6441"
    sha256 cellar: :any,                 sonoma:        "355e7aba65c9fb0d021364394e3a624a179ceb2637854ea7dc14f1f32ca1d821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01b9bedc843d423503bdb54fefcbd30ef38d5637aeafb84425072ad0633836eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "286bb5385c718f5f07af28c94b0f743cac31d74c5a5f9dc097864981beac5527"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
