class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "38c5f3a61efa6e3e6f2556ea6220c171ffabd691852258cb3efd02337d7e5a84"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "835cb825d68e5cf4522eb49b0090263320ecb7fef08214f480496738cc93fe19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6a3b61de6173f309492d7e8c1432ac141421052b93b130eeed59345f5b6798d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bbbbde644fc571b0c5adfe3c02641941630e45d21d9e1d69089e5fc61ac07bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26db3de8347b2926ce0e21c3537d9f40504fd81af19328579fc8dd38ec92b981"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0a0b1432131aacff619c19775e8c87539e214d4ec4dceb412660dbee70067f9"
    sha256 cellar: :any_skip_relocation, ventura:       "1e7506b879634bbb0dfd59aca7911de9313d5298b753e0846a3b4df897fc5de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fbf69ca104b15e2ed37db430e6901439c20240bf9cc6d2cf327642d7d139373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74f5717f9aa07b1153c884d5caf5c36f04ee09baea2ed60313c6a6b96421f210"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end
