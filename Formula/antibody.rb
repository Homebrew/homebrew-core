class Antibody < Formula
  desc "The fastest shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v4.2.0.tar.gz"
  sha256 "552d94e2a0e5b3b93f8659f0a9ed5bdae4622c46a2418ca2a40573862fc991dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "213620404c46edd274afa7ce18505228639b6eff07206a9c5db791b9ae98f6a0" => :catalina
    sha256 "d85294b01d76ac4fae8c9ae9c331f4cd26d3c397a024f5edc2891b4a881fe6a8" => :mojave
    sha256 "140c847a4b90705e0b2c4e84ab4a3998e0800b646f79034420679a63644d9154" => :high_sierra
    sha256 "c7cbfedc71307426d7d83602be02d5f46f3ad8d53ec6c46cd6f26e07c226f641" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/antibody/antibody"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "go", "build", "-ldflags", "-X main.version=#{version}"
      bin.install "antibody"
    end
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
