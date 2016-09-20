class Libmongoclient < Formula
  desc "C and C++ driver for MongoDB"
  homepage "https://www.mongodb.org"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/legacy-0.0-26compat-2.6.12.tar.gz"
  sha256 "e4245210a8fdc9282b1d48eae6ef7448557f9e325b7d1d5c3ac9ba89120839ab"
  head "https://github.com/mongodb/mongo-cxx-driver.git", :branch => "26compat"

  bottle do
    sha256 "d3d4000249b00eccfe72be5e32ff13282cd227123bd7ae34056d77cdefb3f0d6" => :el_capitan
    sha256 "1d84db7d1de7df82c7b5cb1e69eb619d4e27ba739af6b48440c8ccf25a5e97bc" => :yosemite
    sha256 "6fd8e141443fc7cac43a76ba2474e9e15cb4e0c2e66a9de5a1d9e1886dcf4cd4" => :mavericks
  end

  option :cxx11

  depends_on "scons" => :build

  if build.cxx11?
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if build.cxx11?

    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      --cc=#{ENV.cc}
      --cxx=#{ENV.cxx}
      --extrapath=#{Formula["boost"].opt_prefix}
      --full
      --use-system-all
      --sharedclient
    ]

    # --osx-version-min is required to override --osx-version-min=10.6 added
    # by SConstruct which causes "invalid deployment target for -stdlib=libc++"
    # when using libc++
    if MacOS.version >= :sierra
      # no 10.12; reported 4 Oct 2016 https://jira.mongodb.org/browse/CXX-1067
      args << "--osx-version-min=10.11"
    else
      args << "--osx-version-min=#{MacOS.version}"
    end

    args << "--libc++" if MacOS.version >= :mavericks

    scons *args
  end
end
