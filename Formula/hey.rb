class Hey < Formula
  desc "HTTP load generator, ApacheBench (ab) replacement"
  homepage "https://github.com/rakyll/hey"
  url "https://github.com/rakyll/hey.git",
    :tag      => "v0.1.2",
    :revision => "01803349acd49d756dafa2cb6ac5b5bfc141fc3b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c65e3a95c59f8263d5f38a3e605ecdda801511095e54009aaaa2c362a1bfa07e" => :mojave
    sha256 "8de8655664bfa9ad639e113db3b21d517b2bd35a7d6efa0796cc74eb594451a3" => :high_sierra
    sha256 "901cfcb578352c650a3e7ecb77e5102effdea8e6c8bcd76e4b14021e57d3a189" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/rakyll/hey"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"hey"
      prefix.install_metafiles
    end
  end

  test do
    output = "[200]	200 responses"
    assert_match output.to_s, shell_output("#{bin}/hey https://google.com")
  end
end
