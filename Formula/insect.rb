require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-4.7.0.tgz"
  sha256 "a5f5fbd4f4a50362e611a7be7585fb24b973219857f8a56290ae4b95b7f1f00f"

  bottle do
    cellar :any_skip_relocation
    sha256 "abed9facd44c3447ed54a84d9bc8b0068ceb9ae1ac216ded9671f38d5e8ec281" => :sierra
    sha256 "cc59874d2b14a17563440afef00f9e0388f24470d1d7e4c6f89ecf462b052021" => :el_capitan
    sha256 "3761085e0b40a969472de44c64618d2e76d4d3605b17db5d047361da0f0a9b2a" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "120000 ms", shell_output("#{bin}/insect '1 min + 60 s -> ms'").chomp
    assert_equal "299792458 m/s", shell_output("#{bin}/insect speedOfLight").chomp
  end
end
