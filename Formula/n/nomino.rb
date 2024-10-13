class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/refs/tags/1.3.5.tar.gz"
  sha256 "35df10b30608c6ce733fe57625247621f8b2c51d99dc68421114b54880424ed2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1358ac2ac5e8252d7a87dcfa15bf8d762daa576f1b7d913ea736c25a9323f5dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7167bdcda8987fae6d1176853b20a72bb8fe1b37117e18f8d085405466f33836"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8f1894e5657149e1419fb5a43fe1efc457c5fbacf8eaff944025bfc13ad1395"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38818cce18f4df79b6aec98138c1387db5e1dc586a0af76bea15239adae99f7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4776ca97dfc0222a313f0c7702b610e9c7040606717da6fbacbcfc517d83127e"
    sha256 cellar: :any_skip_relocation, ventura:        "2032516b17fb64a98e099c513abd1dfd4d390fa9ae2c61d5360f8cdb3f76e1af"
    sha256 cellar: :any_skip_relocation, monterey:       "c0f46889b17cec7968f7ff3613a1fe6a52c9d65b0f3ae4005701e8b8063f19fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98d84ebaa4e520ef1863c757108a97fcd8cec5c467efdd3651733a8d72c8dfdd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"nomino", "-e", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_predicate testpath/"Homebrew-#{n}.txt", :exist?
    end
  end
end
