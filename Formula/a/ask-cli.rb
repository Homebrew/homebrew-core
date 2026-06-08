class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://github.com/alexa/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.30.7.tgz"
  sha256 "437b55f774064e053b0185956afc69ecb38a8b53c996a6e1e49960918b54f909"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6ec89ac010d0a2464553452e947e5ce7944a71a658e470a756118e9d3565282e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a883f88d9896627c807417adb1d23d9884dbbd65f7fbc1060b80315fc1093150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26fa2cfd5a670de545967dc8aecf123ac3e0e71b9f92735a82dd81e8e2219458"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fee36de070aab95a6baf2f7e6a8310a5d109e543f5edeeebca4a8fb75eff82e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a726d74c5e74806f900274563d143f998b4d9222ab310ac43ed0345e39d2b07"
    sha256 cellar: :any_skip_relocation, sonoma:         "50dcfa2070028a255e11a25a05a264a9fc5daa156cb9517914fd3a560e116ace"
    sha256 cellar: :any_skip_relocation, ventura:        "eed5bf23802e3c9e24250a75088dfd170936908b1630c4ca6528ec08de93bcde"
    sha256 cellar: :any_skip_relocation, monterey:       "08fefe63b075593ac0cb4c75d42f6c2ab48bb62d9c630b4b59eefbe69de6d955"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5075ee29be0cae332a709af27e7ac67c1040dba2bdd1e9b99af77ab595155ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a076d74bb089649513e80702d85a273a67c3f453ad1ef4ca962f55f175d83c81"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "File #{testpath}/.ask/cli_config not exists.", output
  end
end
