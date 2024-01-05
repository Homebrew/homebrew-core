# instruction followed here: https://docs.brew.sh/Formula-Cookbook#an-introduction

class Capy < Formula
  desc "<placeholder>"                              # A description of the software
  homepage "<placeholder>"                          # url to homepage
  url "https://example.com/archive/v1.0.0.tar.gz"   # url for the archive
  sha256 "abcdef1234567890abcdef1234567890"         

  # Additional options, dependencies, and installation steps go here

  def install
    print "install capy!"
  end
end