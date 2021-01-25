class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.24.0.tar.gz"
  sha256 "fa61ad9a6ea4b56b14016b74f081469bf7b63a2f56ae84d2bbc153a1d8dac0b7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4b61190d240b280e1f7f63a5b1b352e4150793e60044bad0bc8a75df73ce609" => :big_sur
    sha256 "8d286b6aebb4e352023f4c63f1c20a8480afb67ad58d7a3129586abdddbaf395" => :arm64_big_sur
    sha256 "b3bfa6f483ba6d5d4cafb55830ecea6afa83fb22a3f2c972872b08a145f3f938" => :catalina
    sha256 "fba4abde3df992e6cb9a654aa902f6c72e844da78f1a397f4a67b65ecc36b6ba" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
