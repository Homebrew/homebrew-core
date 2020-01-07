class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3340stable.tar.gz"
  version "3.34.0"
  sha256 "a56c8f2a35bea4768dfde1237bae1183edb24d688fd5d25bfc997eb5868b93bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "5aa3c4940b8aeb417828a0df299ee1d348d359e4df4fecdc42125a5ebe8c4f27" => :catalina
    sha256 "fadf3316d92e093050361eed661917858043524e8d6af7699133bef13c285fc4" => :mojave
    sha256 "a10fff7b14554c2de43fe163e320a6d206f3f1204308b3b0d4e40c786d1c5a46" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
