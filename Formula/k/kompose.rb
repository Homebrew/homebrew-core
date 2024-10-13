class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "5e6550f9a8af803d0de7db8107bb8c112c5c93d4dfb95e00b9fdd9e1a57c4c5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f222e337574df062951d757123601eb6b15506aa9fe66affc6d7ae97da06d8f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77c3111025da4a5bbca60e21ff63e519da381f4706bb180a6bf6ab706c9b58f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eec7b1737064213d263a890a5d0ce41bd2fc0710107f084d2aba700767d4fa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2aaca7e6de8631107210cc4d602ab8306f92f1ca2c56fcf8315de9166b6a927"
    sha256 cellar: :any_skip_relocation, sonoma:         "050e86c444b9b532dcf0fa6cd253cffa50576fd1cc856648996474c1826cd360"
    sha256 cellar: :any_skip_relocation, ventura:        "bd9ccb19feada4e5a713e129b53016b4da0d2b931ec5afdc29f3577c04fe2e65"
    sha256 cellar: :any_skip_relocation, monterey:       "44184b14a1fbfc243a20f339de0bfeb162070dccd1c8e7188afbc3d3e4ab3482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5635188e3474228ac1e25a87a1a5d0f88f2b0846f2471f746f86741fc3bb8f0a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
