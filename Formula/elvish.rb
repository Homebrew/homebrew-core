class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.11.tar.gz"
  sha256 "711f67d8730990deed00c3e0c59198c8a51c8441371416faab5ef603c26010b6"
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
             "-X github.com/elves/elvish/build.Version=#{version}", "-o",
             bin/"elvish"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
