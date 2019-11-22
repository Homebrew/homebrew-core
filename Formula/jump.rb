class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.23.0.tar.gz"
  sha256 "decb93cdccf0aff1ed9ab503af320aaa723998178f1d62331e6966726e6487d2"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9f29b875a419a764877e8fa3b4c3afaae42e136ceda0d56d3e61911fb7d3166" => :catalina
    sha256 "125750ca3597f9d628b2fc988c492a5c77e3bbacb18580905d9169c24688049c" => :mojave
    sha256 "03cbd33d75d0928fb0ff6141b4460b76cd288864831147e0b323d0f767d26477" => :high_sierra
    sha256 "e890b010358194bc27f6f6c32d3671e928e8465b93a03f96195308ba7f639c47" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gsamokovarov").mkpath
    ln_s buildpath, buildpath/"src/github.com/gsamokovarov/jump"

    ENV["GO111MODULE"] = "off"
    system "go", "build", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
    man1.install "man/j.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
