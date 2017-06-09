class Hyper < Formula
  desc "Client for HyperHQ's cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
      :tag => "v1.10.12",
      :revision => "5473ab18b84afad71f49d9aed4dafa857e331b4a"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02a49cb75bb64e0b52251b13f344e5d35d12f32ecd61137afd066cf7ac755e7c" => :sierra
    sha256 "fb8056e9d46315ef17b8c00180bd77b37bbad5cdfc224138144ee435c5edc3e9" => :el_capitan
    sha256 "35c0c3b0d8953924091a9738d57de3c4a1b46c9d5bdec4329493d02a7dc94381" => :yosemite
  end

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
