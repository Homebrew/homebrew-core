class Objconv < Formula
  desc "Object file converter and disassembler"
  homepage "http://www.agner.org/optimize/#objconv"
  url "http://www.agner.org/optimize/objconv.zip"
  version "2.42"
  sha256 "01bc452c334e3105a516ffcab854b9af2b71c9505fd05681848b051ebf8337f4"
  def install
    system "unzip", "source.zip",
                    "-dsrc"
    # objconv doesn't have a Makefile, so we have to call
    # the C++ compiler ourselves
    system ENV.cxx, "-o", "objconv",
                    "-O2",
                    *Dir["src/*.cpp"],
                    "--prefix=#{prefix}"
    bin.install "objconv"
  end

  test do
    system "#{bin}/objconv", "-h"
    # TODO: write better tests
  end
end
