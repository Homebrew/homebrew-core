class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/cmd/hz/v0.6.7.tar.gz"
  sha256 "8c2427d6f3e2f326094b793f7f368267dce8a58c7e0d29356d4bfef84a0255e3"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  livecheck do
    url :stable
    regex(%r{^cmd/hz/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc1f60475c7ead9bd19e98cf41c4f3ca14ae792bdee8515b5bc81502121a297c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfa6e9f1b244afab8759fc6e97c7f227370a52a838b4f357bb3dc6cd0521c14f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48fd18259e20df689455caf940379d3517da5a379d1a4b07e9de47ca245f7d46"
    sha256 cellar: :any_skip_relocation, ventura:        "3e19dda489577034e239472212721d6261c441b6734e98b0e29282bf641e4a95"
    sha256 cellar: :any_skip_relocation, monterey:       "ede14230e97850a10ac4770abd1df71c180d4050cd7a46d3b687d8ea4c698ef2"
    sha256 cellar: :any_skip_relocation, big_sur:        "79a41ca946eed6ced6d2a77953b6586707ce2851e43e9d7177dd44b47cd198bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c3bab54808b9cc6bbc508dd182678d20594def9b99b771d80528952d43452b"
  end

  depends_on "go" => :build

  def install
    cd "cmd/hz" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
    bin.install_symlink "#{bin}/hz" => "thrift-gen-hertz"
    bin.install_symlink "#{bin}/hz" => "protoc-gen-hertz"
  end

  test do
    output = shell_output("#{bin}/hz --version 2>&1")
    assert_match "hz version v#{version}", output

    system "#{bin}/hz", "new", "--mod=test"
    assert_predicate testpath/"main.go", :exist?
    refute_predicate (testpath/"main.go").size, :zero?
  end
end
