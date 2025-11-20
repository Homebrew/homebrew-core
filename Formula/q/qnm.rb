class Qnm < Formula
  desc "CLI for querying the node_modules directory"
  homepage "https://github.com/ranyitz/qnm"
  url "https://registry.npmjs.org/qnm/-/qnm-2.10.4.tgz"
  sha256 "205044b4bbc4637917ac55f936c17b2763e622040cfa84acb1a0289b50b21098"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "360bcebfd1a8e6fba957b45863d7601122002474f16895e74e6fbc56100939f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "360bcebfd1a8e6fba957b45863d7601122002474f16895e74e6fbc56100939f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "360bcebfd1a8e6fba957b45863d7601122002474f16895e74e6fbc56100939f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "360bcebfd1a8e6fba957b45863d7601122002474f16895e74e6fbc56100939f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba15766ca2e00720af7c0022eb8c05dbe2bcf2744fd61fa5ededd82da4a0d441"
    sha256 cellar: :any_skip_relocation, ventura:       "ba15766ca2e00720af7c0022eb8c05dbe2bcf2744fd61fa5ededd82da4a0d441"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "360bcebfd1a8e6fba957b45863d7601122002474f16895e74e6fbc56100939f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "360bcebfd1a8e6fba957b45863d7601122002474f16895e74e6fbc56100939f8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qnm --version")

    (testpath/"package.json").write <<~EOS
      {
        "name": "test",
        "version": "0.0.1",
        "dependencies": {
          "lodash": "^4.17.21"
        }
      }
    EOS

    # Simulate a node_modules directory with lodash to avoid `npm install`
    (testpath/"node_modules/lodash/package.json").write <<~EOS
      {
        "name": "lodash",
        "version": "4.17.21"
      }
    EOS

    # Disable remote fetch with `--no-remote`
    output = shell_output("#{bin}/qnm --no-remote lodash")
    assert_match "lodash", output
  end
end
