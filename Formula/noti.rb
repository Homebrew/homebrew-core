class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/3.2.0.tar.gz"
  sha256 "76766deecbd5ed37a9e1af0aa1d79f81e2ed2f2272394f0e980e1cc4036535a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "04ec9a03e16078bb57dcd84634a996c4e9919551925aa4d3a05e77f93b7139ed" => :mojave
    sha256 "9da11dc673dad6a1181e037e2bec94c7a22087d447aeebf4eaa539269bb87a4d" => :high_sierra
    sha256 "82dcaaa6cf13b9278a52137ae6e7e11de9204d43cf4c2e39f9ba4f987425456d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    notipath = buildpath/"src/github.com/variadico/noti"
    notipath.install Dir["*"]

    cd "src/github.com/variadico/noti/cmd/noti" do
      system "go", "build"
      bin.install "noti"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
