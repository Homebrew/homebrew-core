class Libmongoclient < Formula
  desc "C and C++ driver for MongoDB"
  homepage "https://www.mongodb.org"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/legacy-0.0-26compat-2.6.12.tar.gz"
  sha256 "e4245210a8fdc9282b1d48eae6ef7448557f9e325b7d1d5c3ac9ba89120839ab"
  head "https://github.com/mongodb/mongo-cxx-driver.git", :branch => "26compat"

  bottle do
    sha256 "4907896f59be2159c14c5d113e7bd5aed8bd5e53b9b8d9f8bfc033179e3f15a4" => :sierra
    sha256 "52a5b6ac0764be74eea200b9e3012982622762cc2f45e31896819750b1fa4a8d" => :el_capitan
    sha256 "b86a75b625b28a5378c23678a0d02d42b0bfeb01f64d16a7eee111bfa97284b0" => :yosemite
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
