class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/3.3.0.tar.gz"
  sha256 "494e1a83897bfa9123c8292d0b8501b779b5d31b7f43923b8c48543a5404eb7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb7635f4c72aaae3941d8b925b7c1bf11e94ffa01fc6d59c9af999cfab4786b7" => :mojave
    sha256 "274d8b4b522d56a784504ead600f22622d4ac1607e5820706e204bc7609c2073" => :high_sierra
    sha256 "9018dabfa27c7d350393477c108e216d44a130c46614e82f2edd393ed76a479f" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOFLAGS"] = "-mod=vendor"
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/variadico/noti"
    src.install buildpath.children

    cd src.join("cmd/noti") do
      system "go", "build"
      bin.install "noti"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
