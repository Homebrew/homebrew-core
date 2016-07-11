class Hyper < Formula
  desc "client for Hyper_ cloud where container replace VM as the building block"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
    :tag => "v1.10",
    :revision => "603e437099a0dc94943ee10219b35d57221262fa"

  head "https://github.com/hyperhq/hypercli.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/hyperhq"
    ln_s buildpath, "src/github.com/hyperhq/hypercli"
    system "./build.sh"
    bin.install "hyper/hyper"
  end

  test do
    system "#{bin}/hyper", "--help"
  end
end
