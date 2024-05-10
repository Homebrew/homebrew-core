class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "74f6a51ddff9b2dbaa86eb03e4cc1c4958cdbad45561fa89a92fcf2a99e50e3d"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc3da3d58dd7c60ea4e7e2ac8128636dc8a431d64770408b6c97e9e299c6763b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be8c886dd0d26ef59b5c74af4609e72edc6214ed36b89b10f393753cf70ec087"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1167773c7a1153d1334a0150bce47088f49f343b14a452d9d737562015689a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1af52bad3f1a5e08237ad78e57f740c780fc5e3396c0a2312d201bb3aeb4960"
    sha256 cellar: :any_skip_relocation, ventura:        "00470719d822e6aa3c6117d256a1f6bbf95029d29f01fc179edb2966234b54ac"
    sha256 cellar: :any_skip_relocation, monterey:       "2f0889db155239a6f17886902b9676f21137a18888966b04b1f75a2fb5fcc3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f36f6618767aa70bae7f396f661d4993c606464d72fd32e73a2716ac94011dc4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
