class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.2.0/OpenCoarrays-2.2.0.tar.gz"
  sha256 "9311547a85a21853111f1e8555ceab4593731c6fd9edb64cfb9588805f9d1a0d"
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    sha256 "5054b060de8a2822b49a3cb74cac4d1f6a8c13b9b241e5328dbfb1fea126ddc3" => :mojave
    sha256 "557e283bc36c7972b556582e701092933c22d6b505d61375d5afd070c84f47a0" => :high_sierra
    sha256 "af7efdd22b641b3647f621f016c67df1e3ce701c8294f2909e5067864c300f5e" => :sierra
    sha256 "804c9a433b4dead350974f71169eedc388ad485b9a7d038ca71b5bea462a3d32" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"tally.f90").write <<~EOS
      program main
        use iso_c_binding, only : c_int
        use iso_fortran_env, only : error_unit
        implicit none
        integer(c_int) :: tally
        tally = this_image() ! this image's contribution
        call co_sum(tally)
        verify: block
          integer(c_int) :: image
          if (tally/=sum([(image,image=1,num_images())])) then
             write(error_unit,'(a,i5)') "Incorrect tally on image ",this_image()
             error stop 2
          end if
        end block verify
        ! Wait for all images to pass the test
        sync all
        if (this_image()==1) write(*,*) "Test passed"
      end program
    EOS
    system "#{bin}/caf", "tally.f90", "-o", "tally"
    system "#{bin}/cafrun", "-np", "3", "--oversubscribe", "./tally"
  end
end
