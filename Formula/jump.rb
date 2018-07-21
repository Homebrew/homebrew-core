class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.20.0.tar.gz"
  sha256 "8f4eba45110e7200dd06efb8f895ab9f2618ef2e25c7b892acee9b368c8de3a1"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed12462e761dfe7f8b94f725da5e3c7cd5e07e919271f2b7112c7f502ee8f2f3" => :high_sierra
    sha256 "cb3ff0b9a0613978cdabf1116d375f8bbeb1944b5bb2e499b8345584e2486f35" => :sierra
    sha256 "ac590af2dd1b8d49ee547b5cd34e84253d38a7c2023a47e800522b02b1d92e7f" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gsamokovarov").mkpath
    ln_s buildpath, buildpath/"src/github.com/gsamokovarov/jump"

    system "go", "build", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
