class Ifacemaker < Formula
  desc "Generate interfaces from structure methods"
  homepage "https://github.com/vburenin/ifacemaker"
  url "https://github.com/vburenin/ifacemaker/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "36d1b93300169c2d9d607fc7c082ff62914300e2d20f67250113d0f9acf71457"
  license "Apache-2.0"
  head "https://github.com/vburenin/ifacemaker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94db1845c66afa670c6b7e21d5d552918f22eee09a0f08f1133f0ee030f7a78e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6154bb922ed27a72a91b0d10e5ec06218ff8b9a49b247fae68a65dbc948621f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6154bb922ed27a72a91b0d10e5ec06218ff8b9a49b247fae68a65dbc948621f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6154bb922ed27a72a91b0d10e5ec06218ff8b9a49b247fae68a65dbc948621f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bfa1e6a33785aedb8ccdf3cb1289a4401000966fbaeea575f5b40cfd3dca554"
    sha256 cellar: :any_skip_relocation, ventura:       "6bfa1e6a33785aedb8ccdf3cb1289a4401000966fbaeea575f5b40cfd3dca554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3965817642d73ac92add1f56c90513f1aea6afb7aa0062554ced5e4811e0f8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25971c5b2fee2f1a24f267bef1f1e9a6070a1f3f5bfa6a693012dc07b2de1d13"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"human.go").write <<~GO
      package main

      type Human struct {
        name string
      }

      // Returns the name of our Human.
      func (h *Human) GetName() string {
        return h.name
      }
    GO

    output = shell_output("#{bin}/ifacemaker -f human.go -s Human -i HumanIface -p humantest " \
                          "-y \"HumanIface makes human interaction easy\"" \
                          "-c \"DONT EDIT: Auto generated\"")
    assert_match "type HumanIface interface", output
  end
end
