class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.12.tar.gz"
  sha256 "edd03f4acf50beb03a663804e4da8b9d13805d471245c47c1b71f24c125cb9a2"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8900fd1eeaeacf2125d852ef1b3296b0c5ea4db260d1ae3575da46e3853bb4ca" => :high_sierra
    sha256 "807d836f433fe94e3bc87e85eb30c33070acec97304fa25d90a0f305b0931ebf" => :sierra
    sha256 "95790ba99de1ef6e2fcdd10019a2fcf72ed703e0e0292bec0ab8ad3089c140aa" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-ldflags",
             "-X github.com/elves/elvish/buildinfo.Version=#{version}", "-o",
             bin/"elvish"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
